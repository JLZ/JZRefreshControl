//
//  Character.h
//  JZRefreshControlExample
//
//  Created by Jeremy Zedell on 1/21/14.
//  Copyright (c) 2014 Jeremy Zedell. All rights reserved.
//

#ifndef JZRefreshControlExample_Character_h
#define JZRefreshControlExample_Character_h

@protocol Character <NSObject>
- (void)tick:(CGFloat)delta;
@end

#endif
