//
//  MacrosHeader.h
//  ObjectiveCTesting
//
//  Created by Svilen Kirov on 08/09/2022.
//

#ifndef MacrosHeader_h
#define MacrosHeader_h

#if DEBUG
  #define LogDebug(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
#else
  #define LogDebug(fmt, ...)
#endif

#endif /* MacrosHeader_h */
