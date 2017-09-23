//
//  bridging_header.h
//  rvcmac
//
//  Created by Nikita Titov on 14/09/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

#ifndef bridging_header_h
#define bridging_header_h

#include <signal.h>
#include "common.h"
#include "rvc_shared.h"

int rvc_list_connections(int, char * _Nonnull * _Nonnull);
int rvc_get_status(const char * _Nonnull, int, char * _Nonnull * _Nonnull);

#endif /* bridging_header_h */
