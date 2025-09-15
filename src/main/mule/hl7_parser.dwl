package hl7.parser

%dw 2.0
output application/json

fun parse_hl7_message(str_message) {
    if (str_message == null or str_message == "") 
        return { error: "Invalid HL7 message" }

    var segments = str_message splitBy "|"
    var parsedMessage = {}

    var segmentMapping = {
        "MSH": [
            { "segment_ID": 0 },
            { "encoding_characters": 1 },
            { "sending_application": 2 },
            { "sending_facility": 3 },
            { "receiving_application": 4 },
            { "receiving_facility": 5 },
            { "message_date_time": 6 },
            { "security": 7 },
            { "message_type": 8 },
            { "message_control_ID": 9 },
            { "processing_ID": 10 },
            { "version_ID": 11 },
            { "sequence_number": 12 },
            { "continuation_pointer": 13 },
            { "accept_ack_type": 14 },
            { "application_ack_type": 15 },
            { "country_code": 16 },
            { "character_set": 17 },
            { "principal_language": 18 },
            { "alt_character_set_handling": 19 }
        ],
        "MSA": [
            { "segment_ID": 0 },
            { "acknowledgment_code": 1 },
            { "message_control_ID": 2 },
            { "text_message": 3 },
            { "expected_sequence_number": 4 },
            { "delayed_acknowledgment_type": 5 },
            { "error_condition": 6 }
        ],
        "ERR": [
            { "segment_ID": 0 },
            { "error_code_and_loc": 1 }
        ]
    }

    for (segmentIndex in (0 to sizeOf(segments) - 1)) {
        var segment = segments[segmentIndex]
        var segmentName = segment[0]
        var fields = segmentMapping[segmentName]
        if (fields != null) {
            parsedMessage[segmentName] = []
            for (field in fields) {
                var fieldName = field.keys()[0]
                var fieldIndex = field[fieldName]
                if (fieldIndex < sizeOf(segment)) {
                    parsedMessage[segmentName] ++ { (fieldName): segment[fieldIndex] }
                }
            }
        }
    }

    return parsedMessage
}