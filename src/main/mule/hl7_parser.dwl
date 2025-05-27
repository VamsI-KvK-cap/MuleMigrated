package main.mule

%dw 2.0
output application/json

fun parse_hl7_message(str_message) {
  var segments = str_message splitBy "|"
  var parsed_message = {}

  var segment_mapping = {
    "MSH": [
      { "segment_ID": 0, "logical_name": "segment_ID" },
      { "encoding_characters": 1, "logical_name": "encoding_characters" },
      { "sending_application": 2, "logical_name": "sending_application" },
      { "sending_facility": 3, "logical_name": "sending_facility" },
      { "receiving_application": 4, "logical_name": "receiving_application" },
      { "receiving_facility": 5, "logical_name": "receiving_facility" },
      { "message_date_time": 6, "logical_name": "message_date_time" },
      { "security": 7, "logical_name": "security" },
      { "message_type": 8, "logical_name": "message_type" },
      { "message_control_ID": 9, "logical_name": "message_control_ID" },
      { "processing_ID": 10, "logical_name": "processing_ID" },
      { "version_ID": 11, "logical_name": "version_ID" },
      { "sequence_number": 12, "logical_name": "sequence_number" },
      { "continuation_pointer": 13, "logical_name": "continuation_pointer" },
      { "accept_ack_type": 14, "logical_name": "accept_ack_type" },
      { "application_ack_type": 15, "logical_name": "application_ack_type" },
      { "country_code": 16, "logical_name": "country_code" },
      { "character_set": 17, "logical_name": "character_set" },
      { "principal_language": 18, "logical_name": "principal_language" },
      { "alt_character_set_handling": 19, "logical_name": "alt_character_set_handling" }
    ],
    "MSA": [
      { "segment_ID": 0, "logical_name": "segment_ID" },
      { "acknowledgment_code": 1, "logical_name": "acknowledgment_code" },
      { "message_control_ID": 2, "logical_name": "message_control_ID" },
      { "text_message": 3, "logical_name": "text_message" },
      { "expected_sequence_number": 4, "logical_name": "expected_sequence_number" },
      { "delayed_acknowledgment_type": 5, "logical_name": "delayed_acknowledgment_type" },
      { "error_condition": 6, "logical_name": "error_condition" }
    ],
    "ERR": [
      { "segment_ID": 0, "logical_name": "segment_ID" },
      { "error_code": 1, "logical_name": "error_code" }
    ]
  }

  for (segment in segments) {
    var segment_name = segment[0]
    var fields = segment splitBy "|"
    var mapped_fields = []

    for (field in segment_mapping[segment_name]) {
      var field_index = field["segment_ID"]
      var logical_name = field["logical_name"]
      mapped_fields ++ { (logical_name): fields[field_index] }
    }

    parsed_message[segment_name] = mapped_fields
  }

  return parsed_message
}