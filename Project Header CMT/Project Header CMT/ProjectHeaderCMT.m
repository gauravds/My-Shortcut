#import "ProjectHeaderCMT.h"
#import "VVKeyboardEventSender.h"
#import "NSTextView+VVTextGetter.h"
#import "VVTextResult.h"

@interface ProjectHeaderCMT()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation ProjectHeaderCMT

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textStorageDidChange:)
                                                 name:NSTextDidChangeNotification
                                               object:nil];
    
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"GDS Check v1.0.0" action:@selector(doMenuAction) keyEquivalent:@""];
        //[actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

// Sample Action, for menu item:
- (void)doMenuAction
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Hello, GauravDS, its v1.0.0"];
    [alert runModal];
}

- (void) textStorageDidChange:(NSNotification *)noti {
    
    if ([[noti object] isKindOfClass:[NSTextView class]]) {
        NSTextView *textView = (NSTextView *)[noti object];
        VVTextResult *currentLineResult = [textView vv_textResultOfCurrentLine];
        
        if (currentLineResult) {
            NSString *documentationString = nil;
            if ([currentLineResult.string isEqualToString:@"``1"]) {
                documentationString = @"//\n\
                //  <#ClassName#>.h\n\
                //  PunchhCoreKit\n\
                //\n\
                //  Copyright (c) 2013 Punchh. All rights reserved.\n\
                //";
            } else if ([currentLineResult.string isEqualToString:@"``2"]) {
                documentationString = @"//\n\
                //  Copyright (c) 2013 Punchh. All rights reserved.\n\
                //\n";
            }
            
            if (!documentationString) {
                return;
            }
            
            //Save current content in paste board
            NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
            NSString *originPBString = [pasteBoard stringForType:NSPasteboardTypeString];
            
            //Set the doc comments in it
            [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
            [pasteBoard setString:documentationString forType:NSStringPboardType];
            
            //Begin to simulate keyborad pressing
            VVKeyboardEventSender *kes = [[VVKeyboardEventSender alloc] init];
            [kes beginKeyBoradEvents];
            //Cmd+delete Delete current line
            [kes sendKeyCode:kVK_Delete withModifierCommand:YES alt:NO shift:NO control:NO];
            //if (shouldReplace) [textView setSelectedRange:resultToDocument.range];
            //Cmd+V, paste (which key to actually use is based on the current keyboard layout)
            NSInteger kKeyVCode = kVK_ANSI_V;
            [kes sendKeyCode:kKeyVCode withModifierCommand:YES alt:NO shift:NO control:NO];
            
            //The key down is just a defined finish signal by me. When we receive this key, we know operation above is finished.
            [kes sendKeyCode:kVK_F20];
            
            [kes sendKeyCode:kVK_Tab withModifierCommand:NO alt:NO shift:YES control:NO];
            
            //Restore previois patse board content
//            [pasteBoard setString:originPBString forType:NSStringPboardType];
        }
        
        
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
