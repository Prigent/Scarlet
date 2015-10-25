//
//  Constants.h
//  Voitures.com
//
//  Created by Damien PRACA on 07/10/14.
//  Copyright (c) 2014 HighConnexion. All rights reserved.
//

//---------------------------------------

#pragma mark - Constants

#define kHockeyAppIdentifierProd                    @"bdba920c7fd0087ef5098dfea57e7974"
#define kHockeyAppIdentifierPreprod                 @"46d6780917325ce5661d566f74298c98"


//---------------------------------------

#pragma mark - Colors
#define UICOLOR_NAVBAR_GREY             [UIColor colorWithRed:(245.0f/255.0f) green:(245.0f/255.0f) blue:(245.0f/255.0f) alpha:1.0]
#define UICOLOR_BLUE                    [UIColor colorWithRed:(10.0f/255.0f) green:(42.0f/255.0f) blue:(97.0f/255.0f) alpha:1.0]
#define UICOLOR_RED                     [UIColor colorWithRed:(197.0f/255.0f) green:(0.0f/255.0f) blue:(4.0f/255.0f) alpha:1.0]
#define UICOLOR_CELL_BG_GRAY            [UIColor colorWithRed:(172.0f/255.0f) green:(172.0f/255.0f) blue:(172.0f/255.0f) alpha:1]

//---------------------------------------


#pragma mark - URLS
#define URL_BASE_RECETTE                @"http://om.xpfabric.com"
#define URL_BASE_PROD                   @"https://api.om.net"

#define URL_BASE_HTML_RECETTE           @"http://om.xpfabric.com"
#define URL_BASE_HTML_PROD              @"http://www.om.net"

#define SECRET_PUSH_RECETTE             @"dri586zet572"
#define SECRET_PUSH_PROD                @"dpt564upk259"

#define API_PUSH_RECETTE                @"OM_Dtu159aZb491"
#define API_PUSH_PROD                   @"OM_PhY159dmN364"


#define SECRET_PUSH                     SECRET_PUSH_PROD
#define API_PUSH                        API_PUSH_PROD
#define URL_BASE                        URL_BASE_PROD
#define URL_BASE_HTML                   URL_BASE_HTML_PROD


/*
#define SECRET_PUSH                     SECRET_PUSH_RECETTE
#define API_PUSH                        API_PUSH_RECETTE
#define URL_BASE                        URL_BASE_RECETTE
#define URL_BASE_HTML                   URL_BASE_HTML_RECETTE
*/


#define URL_BASE_IMAGE_ARTICLE          @"/sites/default/files/styles/mobile_edito/public/"
#define URL_BASE_THUMB_ARTICLE          @"/sites/default/files/styles/vignettes_listes/public/"
#define URL_BASE_IMAGE_EFFECTIF         @"/sites/default/files/"
#define URL_PATH_ACTU                   @"/app/flux_app_actu"
#define URL_PATH_VIDEO                  @"/app/flux_app_video"
#define URL_PATH_DIAPO                  @"/app/flux_app_diapo"
#define URL_PATH_PHOTO                  @"/app/flux_app_photo"
#define URL_PATH_CLASSEMENT             @"/app/flux_app_classement"
#define URL_PATH_EFFECTIF               @"/app/flux_app_effectif"
#define URL_PATH_LIVE                   @"/app/flux_app_livetexte"
#define URL_PATH_COMPOSITION            @"/app/flux_app_composition"
#define URL_PATH_CALENDRIER             @"/app/flux_app_calendrier"
#define URL_PATH_TAXOMONIE              @"/app/flux_app_taxo"
#define URL_PATH_ARTICLE                @"/app/flux_app_article"
#define URL_PATH_USER                   @"/app/flux_app_user"

#define URL_PUSH_CHANNEL                @"http://highnotifapi.hcnx.eu/api/1.0/get_channels"
#define URL_SUBPUSH_CHANNEL             @"http://highnotifapi.hcnx.eu/api/1.0/subscribe_to_channels"
#define URL_UNSUBPUSH_CHANNEL           @"http://highnotifapi.hcnx.eu/api/1.0/unsubscribe_to_channels"



#define URL_SHARE_URL                   @"http://www.om.net/node/"
#define URL_PATH_DIGITICK               @"https://ssl.digitick.com/inout/iphoneapiom/index.php"

#define URL_PATH_FORGET                 @"xxx"
#define APPLE_APP_ID                    @"346179130"


#define REQUEST_CREDENTIALS @{@"lang":@"FR", @"login":@"mobile", @"pwd":@"ACBA45A2A11CV13EEBA5D0A7AP22BCE6120P177E",@"output_response":@"json"}

//---------------------------------------

#pragma mark - Keywords

#define kerror                          @"error"
#define kcode                           @"code"
#define kmessage                        @"message"
#define kdata                           @"data"
#define kuser                           @"user"
#define kid                             @"id"
#define kdescription                    @"description"
#define ktimestamp                      @"ts"
#define kitems                          @"items"

#define ktoken                          @"token"
#define kfirstname                      @"firstname"
#define klastname                       @"lastname"


#define knbElementPerPage                15
