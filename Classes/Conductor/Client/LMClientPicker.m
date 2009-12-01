//
//  LMClientPicker.m
//  Bottle
//
//  Created by Sam Dean on 01/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LMClientPicker.h"

@interface Client : NSObject {
    NSString *peerID;
    NSString *name;
    GKPeerConnectionState connectionState;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *peerID;
@property (nonatomic, assign) GKPeerConnectionState connectionState;

@end


@implementation LMClientPicker

@synthesize connectionTypesMask, delegate, visible, clientTableView;

- (id) init {
    if (self = [super initWithNibName:@"LMClientPicker" bundle:nil]) {
        connectionTypesMask = GKPeerPickerConnectionTypeNearby;
        
        clients = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void) dealloc {
    [session setAvailable:NO];
    [session setDelegate:nil];
    [session setDataReceiveHandler:nil withContext:nil];
    [session release];
    [clients release];
    [clientTableView release];
    [super dealloc];
}

- (void) show {
    // Get the session to use to connect (pretend that we are a GKPeerPickerController!)
    if ([delegate respondsToSelector:@selector(peerPickerController:sessionForConnectionType:)])
        session = [[delegate peerPickerController:(id)self sessionForConnectionType:connectionTypesMask] retain];
    if (nil == session)
        session = [[GKSession alloc] initWithSessionID:nil displayName:nil sessionMode:GKSessionModePeer];

    // Initialize the GKSession and try to connect
	[session setDelegate:self];
	[session setDataReceiveHandler:self withContext:nil];
	[session setAvailable:YES];
    
    // Create a view to display the list of clients that we have found
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.view];
    [self.view setCenter:CGPointMake(window.frame.size.width/2, window.frame.size.height/2)];
}

- (void) dismiss {
    [session setAvailable:NO];
    [session setDelegate:nil];
    [session setDataReceiveHandler:nil withContext:nil];
    [session release];
    session = nil;
    [self.view removeFromSuperview];
}

- (IBAction) cancel {
    [delegate peerPickerControllerDidCancel:(id)self];
}

- (void) viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
#pragma mark GKSessionDelegate methods

- (void)session:(GKSession *)session_ peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    // Do we know about this client already?
    Client *client = nil;
    for (Client *temp in clients) {
        if ([client.peerID isEqualToString:peerID]) {
            client = temp;
            break;
        }
    }
    
    // If not, create it and remember it
    if (nil == client) {
        client = [[[Client alloc] init] autorelease];
        [clients addObject:client];
        client.peerID = peerID;
        client.name = [session_ displayNameForPeer:peerID];
    }
    
    // Remember it's state
    client.connectionState = state;
    
    // Some state changes require that we forget about this client!
    if (GKPeerStateUnavailable == state)
        [clients removeObject:client];
    
    // Refresh the table
    [clientTableView reloadData];
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    NSLog(@"Failed with a error %@", error);
    for (id key in [error userInfo])
        NSLog(@" %@ : %@", key, [[error userInfo] objectForKey:key]);
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
}

#pragma mark -
#pragma UITableView delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LMClientPickerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    int index = [indexPath indexAtPosition:1];
    if (clients.count > index) {
        cell.textLabel.text = [[clients objectAtIndex:index] name];
    } else {
        cell.textLabel.text = nil;
    }
	
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MAX(5, clients.count);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end


@implementation Client

@synthesize name, peerID, connectionState;

- (void) dealloc {
    [peerID release];
    [name release];
    [super dealloc];
}

@end

