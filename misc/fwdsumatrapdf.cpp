/* vim: ts=4 sw=4 expandtab:
 *
 * MinGW/MinGW-W64
 * $ g++ -std=c++11 -static -o fwdsumatrapdf.exe fwdsumatrapdf.cpp -luser32 -lshell32 -ladvapi32 -lshlwapi
 *
 * Clang/LLVM
 * $ clang++ -std=c++11 -static -o fwdsumatrapdf.exe fwdsumatrapdf.cpp -luser32 -lshell32 -ladvapi32 -lshlwapi -isystem /mingw/lib/gcc/mingw32/4.8.1/include/c++ -isystem /mingw/lib/gcc/mingw32/4.8.1/include/c++/mingw32
 *
 * Microsoft Visual Studio Community
 * >cl fwdsumatrapdf.cpp user32.lib advapi32.lib shlwapi.lib
 */

#include <windows.h>
#include <shlwapi.h>
#include <ddeml.h>
#if !defined _MSC_VER
#include <shellapi.h>
#endif
#include <iostream>
#include <sstream>
#include <iomanip>
#include <array>
#include <string>
#include <cstring>
#include <cstdlib>
#include <cwchar>
#include <cerrno>
#if defined _MSC_VER
#pragma comment(lib, "user32.lib")
#pragma comment(lib, "advapi32.lib")
#pragma comment(lib, "shlwapi.lib")
#endif

auto static constexpr timeout = 10000;
auto static existSumatraHWND = FALSE;

auto CALLBACK GetSumatraHWND(HWND hwnd, LPARAM lParam) -> BOOL
{
	UNREFERENCED_PARAMETER(lParam);

	auto constexpr maxSize = 1024;
	auto windowText = std::array<wchar_t, maxSize>{L""};
	::GetWindowTextW(hwnd, windowText.data(), maxSize);

	if (windowText[0] == L'\0') {
		return TRUE;
	}

	wchar_t* title = nullptr;
	if ((title = std::wcsrchr(windowText.data(), L'S')) == nullptr) {
		return TRUE;
	}

	if (std::wcscmp(title, L"SumatraPDF") != 0) {
		return TRUE;
	}

	existSumatraHWND = TRUE;

	return TRUE;
}

namespace sumatrapdfclient
{
	class DDEClient
	{
	private:
		std::basic_string<wchar_t> server;
		std::basic_string<wchar_t> topic;
		DWORD idInstance;
		HSZ hszServer;
		HSZ hszTopic;
		HCONV hConvClient;
		HDDEDATA hDdeData;
		HDDEDATA hDdeTransactionData;

	public:
		explicit DDEClient(const std::basic_string<wchar_t>& server, const std::basic_string<wchar_t>& topic)
		{
			this->server = server;
			this->topic = topic;
			this->idInstance = 0;
			this->hszServer = nullptr;
			this->hszTopic = nullptr;
			this->hConvClient = nullptr;
			this->hDdeData = nullptr;
			this->hDdeTransactionData = nullptr;
		}

		~DDEClient()
		{
			if (this->hDdeTransactionData != nullptr) {
				if (::DdeFreeDataHandle(this->hDdeTransactionData) == FALSE) {
					if (::DdeGetLastError(this->idInstance) != 0) {
						std::wcerr << L"DdeFreeDataHandle error" << std::endl;
					}
				}
			}

			if (this->hDdeData != nullptr) {
				if (::DdeFreeDataHandle(this->hDdeData) == FALSE) {
					if (::DdeGetLastError(this->idInstance) != 0) {
						std::wcerr << L"DdeFreeDataHandle error" << std::endl;
					}
				}
			}

			if (this->hszServer != nullptr) {
				if (::DdeFreeStringHandle(this->idInstance, this->hszServer) == FALSE) {
					std::wcerr << L"DdeFreeStringHandle error" << std::endl;
				}
			}

			if (this->hszTopic != nullptr) {
				if (::DdeFreeStringHandle(this->idInstance, this->hszTopic) == FALSE) {
					std::wcerr << L"DdeFreeStringHandle error" << std::endl;
				}
			}

			if (this->hConvClient != nullptr) {
				if (::DdeDisconnect(this->hConvClient) == FALSE) {
					std::wcerr << L"DdeDisconnect error" << std::endl;
				}
			}

			if (this->idInstance != 0) {
				if (::DdeUninitialize(this->idInstance) == FALSE) {
					std::wcerr << L"DdeUninitialize error" << std::endl;
				}
			}

		}

		auto execute(const std::basic_string<wchar_t>& command) -> int
		{
			if (::DdeInitializeW(&(this->idInstance), reinterpret_cast<PFNCALLBACK>([]() -> HDDEDATA (CALLBACK *)(UINT uType, UINT uFmt, HCONV hconv, HSZ hsz1, HSZ hsz2, HDDEDATA hdata, DWORD dwData1, DWORD dwData2) { return nullptr; }()), APPCMD_CLIENTONLY, 0) != DMLERR_NO_ERROR) {
				std::wcerr << L"DdeInitializeW error" << std::endl;
				return 4;
			}

			if ((this->hszServer = ::DdeCreateStringHandleW(this->idInstance, this->server.c_str(), CP_WINUNICODE)) == nullptr) {
				std::wcerr << L"DdeCreateStringHandleW error" << std::endl;
				return ::DdeGetLastError(this->idInstance);
			}

			if ((this->hszTopic = ::DdeCreateStringHandleW(this->idInstance, this->topic.c_str(), CP_WINUNICODE)) == nullptr) {
				std::wcerr << L"DdeCreateStringHandleW error" << std::endl;
				return ::DdeGetLastError(this->idInstance);
			}

			if ((this->hConvClient = ::DdeConnect(this->idInstance, this->hszServer, this->hszTopic, nullptr)) == nullptr) {
				std::wcerr << L"DdeConnect error" << std::endl;
				return ::DdeGetLastError(this->idInstance);
			}

			if ((this->hDdeData = ::DdeCreateDataHandle(this->idInstance, reinterpret_cast<BYTE*>(const_cast<wchar_t*>(command.c_str())), static_cast<DWORD>((command.length() + 1)*sizeof(wchar_t)), 0, nullptr, CF_UNICODETEXT, 0)) == nullptr) {
				std::wcerr << L"DdeCreateDataHandle error" << std::endl;
				return ::DdeGetLastError(this->idInstance);
			}

			if ((this->hDdeTransactionData = ::DdeClientTransaction(reinterpret_cast<BYTE*>(this->hDdeData), static_cast<DWORD>(-1), this->hConvClient, nullptr, 0, XTYP_EXECUTE, timeout, nullptr)) == nullptr) {
				std::wcerr << L"DdeClientTransaction error" << std::endl;
				return ::DdeGetLastError(this->idInstance);
			}

			return 0;
		}

	};
}

auto static RunSumatraPDF(const std::basic_string<wchar_t>& pdf) -> int
{
	auto err = 0;

	static HWND hList;
	::EnumWindows(reinterpret_cast<WNDENUMPROC>(GetSumatraHWND), reinterpret_cast<LPARAM>(hList));

	if (existSumatraHWND == TRUE) {
		return err;
	}

	HKEY subKey = nullptr;
	const auto keyPath = std::basic_string<wchar_t>(LR"(SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SumatraPDF.exe)");
	if (::RegOpenKeyExW(HKEY_LOCAL_MACHINE, keyPath.c_str(), 0, KEY_QUERY_VALUE, &subKey) != ERROR_SUCCESS) {
		err = 1;
	}

	DWORD dwType = 0;
	DWORD sz = 0;
	if (subKey != nullptr) {
		if (::RegQueryValueExW(subKey, nullptr, nullptr, &dwType, nullptr, &sz) != ERROR_SUCCESS) {
			err = 1;
		}
	}

	auto sumatrapdfRegistry = std::basic_string<wchar_t>(sz, L'\0');
	if (subKey != nullptr) {
		if (::RegQueryValueExW(subKey, nullptr, nullptr, &dwType, reinterpret_cast<BYTE*>(const_cast<wchar_t*>(sumatrapdfRegistry.c_str())), &sz) != ERROR_SUCCESS) {
			err = 1;
		}
	}

	if (subKey != nullptr) {
		::RegCloseKey(subKey);
		subKey = nullptr;
	}

	auto sumatrapdf = std::basic_string<wchar_t>{L"SumatraPDF.exe"};
	if (err == 0) {
		if (sumatrapdfRegistry.length() != 0) {
			if (::PathFileExistsW(sumatrapdfRegistry.c_str())) {
				sumatrapdf = sumatrapdfRegistry;
			} else {
				err = 1;
			}
		}
	}

	if (err != 0) {
		err = 0;
		constexpr auto sumatrapdfWin32Default = LR"(C:\Program Files\SumatraPDF\SumatraPDF.exe)";
		constexpr auto sumatrapdfWin64Default = LR"#(C:\Program Files (x86)\SumatraPDF\SumatraPDF.exe)#";
		if (::PathFileExistsW(sumatrapdfWin32Default)) {
			sumatrapdf = sumatrapdfWin32Default;
		} else if (::PathFileExistsW(sumatrapdfWin64Default)) {
			sumatrapdf = sumatrapdfWin64Default;
		} else {
			sumatrapdf = L"SumatraPDF.exe";
		}
	}

	STARTUPINFOW si;
	PROCESS_INFORMATION pi;

#if defined SecureZeroMemory
	SecureZeroMemory(&si, sizeof(si));
	SecureZeroMemory(&pi, sizeof(pi));
#else
	ZeroMemory(&si, sizeof(si));
	ZeroMemory(&pi, sizeof(pi));
#endif

	si.cb = sizeof(si);

	const auto reuseInstance = std::basic_string<wchar_t>{L"-reuse-instance"};
	std::basic_ostringstream<wchar_t> oss;
	oss << L"\"" << sumatrapdf << L"\" " << reuseInstance << L" \"" << pdf << L"\"";
	auto sumatrapdfCommandLine = std::basic_string<wchar_t>{oss.str()};

	if (::CreateProcessW(nullptr, const_cast<wchar_t*>(sumatrapdfCommandLine.c_str()), nullptr, nullptr, FALSE, 0, nullptr, nullptr, &si, &pi) == 0) {
		err = 3;
		return err;
	}

	::WaitForInputIdle(pi.hProcess, timeout);

	return err;
}

auto static DdeExecute(const std::basic_string<wchar_t>& server, const std::basic_string<wchar_t>& topic, const std::basic_string<wchar_t>& command) -> int
{
	auto dde = sumatrapdfclient::DDEClient{server, topic};
	return dde.execute(command);
}

#if defined _MSC_VER
auto wmain(int argc, wchar_t** argv) -> int
#else
auto main() -> int
#endif
{
	auto err = 0;
#if !defined _MSC_VER
	auto argc = 0;
	auto argv = ::CommandLineToArgvW(::GetCommandLineW(), &argc);
#endif

	if (argc != 4) {
		auto hStdError = ::GetStdHandle(STD_ERROR_HANDLE);
		DWORD dwWriteByte;
		wchar_t usage[256] = L"";
		std::wcscat(usage, L"usage: ");
		std::wcscat(usage, argv[0]);
		std::wcscat(usage, L" pdffile texfile line\n");
		WriteConsoleW(hStdError, usage, std::wcslen(usage), &dwWriteByte, nullptr);
		err = 2;
		return err;
	}

	auto const pdf = std::basic_string<wchar_t>{argv[1]};
	auto const tex = std::basic_string<wchar_t>{argv[2]};
	auto const line = std::basic_string<wchar_t>{argv[3]};

	if (std::wcstol(line.c_str(), nullptr, 0) == 0 || errno == ERANGE) {
		std::wcerr << line << L" can't convert to the line number." << std::endl;
		err = -1;
		return err;
	}

	if ((err = RunSumatraPDF(pdf)) != 0) {
		return err;
	}

	auto active = 0;
	std::basic_ostringstream<wchar_t> woss;
	woss << L"[ForwardSearch(\"" << pdf << L"\",\"" << tex << L"\"," << line << L",0,0," << active << L")]";
	auto const forwardSearch = std::basic_string<wchar_t>{woss.str()};
	auto const server = std::basic_string<wchar_t>{L"SUMATRA"};
	auto const topic = std::basic_string<wchar_t>{L"control"};

	if ((err = DdeExecute(server, topic, forwardSearch)) != 0) {
		return err;
	}

	return err;
}
