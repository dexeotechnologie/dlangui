module dlangui.core.logger;

import std.stdio;
import std.datetime;

enum LogLevel : int {
	Fatal,
	Error,
	Warn,
	Info,
	Debug,
	Trace
}

__gshared LogLevel logLevel = LogLevel.Info;
__gshared std.stdio.File logFile;

void setLogLevel(LogLevel level) {
	logLevel = level;
}

void setStdoutLogger() {
	logFile = stdout;
}

void setStderrLogger() {
	logFile = stderr;
}

void setFileLogger(File file) {
	logFile = file;
}

class Log {
	static string logLevelName(LogLevel level) {
		switch (level) {
			case LogLevel.Fatal: return "F";
			case LogLevel.Error: return "E";
			case LogLevel.Warn: return "W";
			case LogLevel.Info: return "I";
			case LogLevel.Debug: return "D";
			case LogLevel.Trace: return "V";
			default: return "?";
		}
	}
	static void log(S...)(LogLevel level, S args) {
		if (logLevel >= level && logFile.isOpen) {
			SysTime ts = Clock.currTime();
			logFile.writef("%04d-%02d-%02d %02d:%02d:%02d.%03d %s  ", ts.year, ts.month, ts.day, ts.hour, ts.minute, ts.second, ts.fracSec.msecs, logLevelName(level));
			logFile.writeln(args);
			logFile.flush();
		}
	}
	static void v(S...)(S args) {
		if (logLevel >= LogLevel.Trace && logFile.isOpen)
			log(LogLevel.Trace, args);
	}
	static void d(S...)(S args) {
		if (logLevel >= LogLevel.Debug && logFile.isOpen)
			log(LogLevel.Debug, args);
	}
	static void i(S...)(S args) {
		if (logLevel >= LogLevel.Info && logFile.isOpen)
			log(LogLevel.Info, args);
	}
	static void w(S...)(S args) {
		if (logLevel >= LogLevel.Warn && logFile.isOpen)
			log(LogLevel.Warn, args);
	}
	static void e(S...)(S args) {
		if (logLevel >= LogLevel.Error && logFile.isOpen)
			log(LogLevel.Error, args);
	}
	static void f(S...)(S args) {
		if (logLevel >= LogLevel.Fatal && logFile.isOpen)
			log(LogLevel.Fatal, args);
	}
}