#include <cxxabi.h>
#include <dlfcn.h>
#include <string>
#include "POSIXPrivate.h"
#include "WAVM/Inline/Assert.h"
#include "WAVM/Platform/Diagnostics.h"

#if WAVM_ENABLE_UNWIND
#define UNW_LOCAL_ONLY
#include "libunwind.h"
#endif

using namespace WAVM;
using namespace WAVM::Platform;

extern "C" const char* __asan_default_options()
{
	return "handle_segv=false"
		   ":handle_sigbus=false"
		   ":handle_sigfpe=false"
		   ":replace_intrin=false";
}

CallStack Platform::captureCallStack(Uptr numOmittedFramesFromTop)
{
	CallStack result;

#if WAVM_ENABLE_UNWIND
	unw_context_t context;
	WAVM_ERROR_UNLESS(!unw_getcontext(&context));

	unw_cursor_t cursor;

	WAVM_ERROR_UNLESS(!unw_init_local(&cursor, &context));
	for(Uptr frameIndex = 0; !result.frames.isFull() && unw_step(&cursor) > 0; ++frameIndex)
	{
		if(frameIndex >= numOmittedFramesFromTop)
		{
			unw_word_t ip;
			WAVM_ERROR_UNLESS(!unw_get_reg(&cursor, UNW_REG_IP, &ip));
			result.frames.push_back(CallStack::Frame{frameIndex == 0 ? ip : (ip - 1)});
		}
	}
#endif

	return result;
}

bool Platform::getInstructionSourceByAddress(Uptr ip, InstructionSource& outSource)
{
#if defined(__linux__) || defined(__APPLE__)
	// Look up static symbol information for the address.
	Dl_info symbolInfo;
	if(dladdr((void*)ip, &symbolInfo))
	{
		WAVM_ASSERT(symbolInfo.dli_fname);
		outSource.module = symbolInfo.dli_fname;
		if(!symbolInfo.dli_sname)
		{
			outSource.function = std::string();
			outSource.instructionOffset = ip - reinterpret_cast<Uptr>(symbolInfo.dli_fbase);
		}
		else
		{
			char demangledBuffer[1024];
			const char* demangledSymbolName = symbolInfo.dli_sname;
			if(symbolInfo.dli_sname[0] == '_')
			{
				Uptr numDemangledChars = sizeof(demangledBuffer);
				I32 demangleStatus = 0;
				if(abi::__cxa_demangle(symbolInfo.dli_sname,
									   demangledBuffer,
									   (size_t*)&numDemangledChars,
									   &demangleStatus))
				{ demangledSymbolName = demangledBuffer; }
			}
			outSource.function = demangledSymbolName;
			outSource.instructionOffset = ip - reinterpret_cast<Uptr>(symbolInfo.dli_saddr);
		}
		return true;
	}
#endif
	return false;
}
