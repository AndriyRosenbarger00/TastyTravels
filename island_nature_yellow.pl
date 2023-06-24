#!/usr/bin/perl
use strict;
use warnings;

#Define packages and libraries
use LWP::UserAgent;
use LWP::Simple;
use JSON;

#Initialise the UserAgent
my $ua = LWP::UserAgent->new;
$ua->agent("MyApp/0.1 ");

#Define URLs
my $base_URL = 'https://www.culinarytourism.org/';
my $places_URL = $base_URL . 'places/';
my $events_URL = $base_URL . 'events/';
 
#Retrieve Places
my $places_JSON = get($places_URL);
my $places = decode_json($places_JSON);
 
# Retrieve Events
my $events_JSON = get($events_URL);
my $events = decode_json($events_JSON);
 
#Loop through places
 foreach my $place ( @$places ) {
    # Retrieve details
    my $details_URL = $places_URL . $place->{'slug'} . '/';
    my $details_JSON = get($details_URL);
    my $details = decode_json($details_JSON);
 
    # Create a string of the place details
    my $place_details_string = $place->{'name'} . ', ' . 
                               $place->{'city'} . ', ' .
                               $place->{'country'} . ': ' .
                               $details->{'description'};
    print $place_details_string . "\n";
 
    #Loop through related events
    my $events_related = $place->{'events'};
    foreach my $event ( @$events_related ) {
        my $event_details_URL = $events_URL . $event->{'slug'} . '/';
        my $event_details_JSON = get($event_details_URL);
        my $event_details = decode_json($event_details_JSON);
        my $event_details_string = 'Event: ' . $event_details->{'name'} . ', ' . 
                                   $event_details->{'start_date'} . ' - ' . 
                                   $event_details->{'end_date'}. ' ---------- ' .
                                   $event_details->{'description'};
 
        print $event_details_string . "\n\n";
    }
 
    print "\n===================================================\n\n";
}

# Define subroutines
sub retrieve_place_details {
    my $place_details_URL = $places_URL . $_[0] . '/';
    my $place_details_JSON = get($place_details_URL);
    my $place_details = decode_json($place_details_JSON);
    my $place_details_string = 'Name: ' . $place_details->{'name'} . ', ' . 
                               'City: ' . $place_details->{'city'} . ', ' .
                               'Country: ' . $place_details->{'country'}. '---------' .
                               'Description: ' . $place_details->{'description'};
 
    return $place_details_string;
}

sub retrieve_event_details {
    my $event_details_URL = $events_URL . $_[0] . '/';
    my $event_details_JSON = get($event_details_URL);
    my $event_details = decode_json($event_details_JSON);
    my $event_details_string = 'Event Name: ' . $event_details->{'name'} . ', ' . 
                               'Start Date: ' . $event_details->{'start_date'} . ' - ' . 
                               'End Date: ' . $event_details->{'end_date'}. '----------' .
                               'Description: ' . $event_details->{'description'};
 
    return $event_details_string;
}

# Main script
my $places_JSON = get($places_URL);
my $places = decode_json($places_JSON);
 
#Loop through places
foreach my $place ( @$places ) {
    # Retrieve and print place details
    my $place_details = &retrieve_place_details($place->{'slug'});
    print $place_details . "\n";
 
    #Loop through related events
    my $events_related = $place->{'events'};
    foreach my $event ( @$events_related ) {
        my $event_details = &retrieve_event_details($event->{'slug'});
        print $event_details . "\n\n";
    }
 
    print "\n===================================================\n\n";
}