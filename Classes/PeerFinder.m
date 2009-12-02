//
//  PeerFinder.m
//  BluetoothTest
//
//  Created by Sam Dean on 02/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PeerFinder.h"
#import "Peer.h"

#import "CommandCoder.h"

@implementation PeerFinder

@synthesize delegate, conductButton;
@synthesize youAreLabel, connectedToLabel;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];

    if (nil==possibles)
        possibles = [[NSMutableArray alloc] initWithCapacity:10];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Create the GKSession
    session = [[GKSession alloc] initWithSessionID:@"BottleRockIt" displayName:nil sessionMode:GKSessionModePeer];
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
    session.available = YES;
    
    // Who are you?
    youAreLabel.text = [NSString stringWithFormat:@"You are %@ (%@)", [session displayName], [session peerID]];
    connectedToLabel.text = @"";
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark GKSessionDelegate methods

- (void)session:(GKSession *)session_ peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    // Get the possible peer
    Peer *peer = nil;
    for (Peer *temp in possibles)
        if ([temp.peerID isEqualToString:peerID]) {
            peer = temp;
            break;
        }
    
    // If it's a new peer, add it to the array
    if (nil == peer) {
        peer = [[Peer alloc] init];
        peer.peerID = peerID;
        peer.displayName = [session_ displayNameForPeer:peerID];
        [possibles addObject:peer];
        [peer release];
    } else {
        // If it's become unavailable, remove it
        if (GKPeerStateUnavailable == state) {
            [[peer retain] autorelease];
            [possibles removeObject:peer];
        }
        
        if (GKPeerStateConnected==state && peer == connectingTo) {
            connectedToLabel.text = @"";
            [connectingTo release];
            connectingTo = nil;
        }
    }
    
    // Get the state of the peer
    peer.state = state;
    
    // Redisplay the table
    [self.tableView reloadData];
    
    // Refresh the conduct button
    conductButton.enabled = [[session peersWithConnectionState:GKPeerStateConnected] count];
}

- (void)session:(GKSession *)session_ didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    // Accept the connection
    NSError *error;
    [session_ acceptConnectionFromPeer:peerID error:&error];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
    connectedToLabel.text = @"";
    [connectingTo release];
    connectingTo = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return possibles.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PeerPickerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    int index = [indexPath indexAtPosition:1];
    Peer *peer = [possibles objectAtIndex:index];
    cell.textLabel.text = peer.displayName;
    cell.detailTextLabel.text = peer.peerID;
    
    switch (peer.state) {
        case GKPeerStateConnecting:
            cell.textLabel.textColor = [UIColor orangeColor];
            break;
            
        case GKPeerStateConnected:
            cell.textLabel.textColor = [UIColor greenColor];
            break;
        
        case GKPeerStateUnavailable:
        case GKPeerStateDisconnected:
            cell.textLabel.textColor = [UIColor grayColor];
            break;
            
        case GKPeerStateAvailable:
        default:
            cell.textLabel.textColor = [UIColor blackColor];
            break;
    }
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get the peer
    Peer *peer = [possibles objectAtIndex:[indexPath indexAtPosition:1]];
    
    // Connect to it
    if (connectingTo)
        [session cancelConnectToPeer:connectingTo.peerID];
    [session connectToPeer:peer.peerID withTimeout:5.0];
    
    // Display the name we are connecting to
    connectedToLabel.text = [NSString stringWithFormat:@"connecting to %@", peer.displayName];
    
    // Remember who this is
    [connectingTo release];
    connectingTo = [peer retain];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    if (session.delegate == self) {
        session.delegate = nil;
        [session setDataReceiveHandler:nil withContext:nil];
    }
    [possibles release];
    [delegate release];
    [super dealloc];
}


- (IBAction) conduct {
    [delegate peerFinder:self isServerWithSession:session];
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peerID inSession: (GKSession *)session_ context:(void *)context {
	// Create the command from the data
	<Command> command = [CommandCoder commandWithData:data];
	switch (command.type) {
		case CommandTypeBecomeClient: {
                // We must become a client for this server
                [delegate peerFinder:self isClientWithSession:session forServer:peerID];
            }
            break;
            
		default:
			break;
	}
}


@end

