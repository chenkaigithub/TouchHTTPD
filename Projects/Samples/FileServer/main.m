//
//  main.m
//  TouchCode
//
//  Created by Jonathan Wight on 20090528.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//     1. Redistributions of source code must retain the above copyright notice, this list of
//        conditions and the following disclaimer.
//
//     2. Redistributions in binary form must reproduce the above copyright notice, this list
//        of conditions and the following disclaimer in the documentation and/or other materials
//        provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY TOXICSOFTWARE.COM ``AS IS'' AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL TOXICSOFTWARE.COM OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those of the
//  authors and should not be interpreted as representing official policies, either expressed
//  or implied, of toxicsoftware.com.

#import <Cocoa/Cocoa.h>

#import "CTCPSocketListener.h"
#import "CTCPSocketListener_Extensions.h"
#import "CHTTPConnection.h"
#import "CHTTPFileSystemHandler.h"
#import "CHTTPServer.h"
#import "CWebDavHTTPHandler.h"
#import "CHTTPStaticResourcesHandler.h"
#import "CHTTPDefaultHandler.h"
#import "CHTTPLogHandler.h"

int main (int argc, const char * argv[])
{
#pragma unused (argc, argv)

NSAutoreleasePool *theAutoreleasePool = [[NSAutoreleasePool alloc] init];

CHTTPServer *theHTTPServer = [[[CHTTPServer alloc] init] autorelease];
[theHTTPServer createDefaultSocketListener];

CHTTPFileSystemHandler *theRequestHandler = [[[CWebDavHTTPHandler alloc] initWithRootPath:@"/Users/schwa/Sites/Test"] autorelease];
[theHTTPServer.defaultRequestHandlers addObject:theRequestHandler];

CHTTPStaticResourcesHandler *theStaticResourceHandler = [[[CHTTPStaticResourcesHandler alloc] init] autorelease];
theStaticResourceHandler.rootDirectory = [@"~/Sites/static" stringByExpandingTildeInPath];
[theHTTPServer.defaultRequestHandlers addObject:theStaticResourceHandler];

CHTTPDefaultHandler *theDefaultHandler = [[[CHTTPDefaultHandler alloc] init] autorelease];
[theHTTPServer.defaultRequestHandlers addObject:theDefaultHandler];

CHTTPLogHandler *theLogHandler = [[[CHTTPLogHandler alloc] init] autorelease];
[theHTTPServer.defaultRequestHandlers addObject:theLogHandler];


[theHTTPServer.socketListener start:NULL];

//NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"webdav://%@:%d", [[NSHost currentHost] name], theHTTPServer.socketListener.port]];
//[[NSWorkspace sharedWorkspace] openURL:theURL];

[theHTTPServer.socketListener serveForever:YES error:NULL];

[theAutoreleasePool drain];
return 0;
}
