package main.mule

%dw 2.0
output application/json

fun parse_hl7_message(str_message) {
  var segments = str_message splitBy "\r"
  var parsed_message = {}

  var segment_mapping = {
    "MSH": [
      "segment_ID",
      "encoding_characters",
      "sending_application",
      "sending_facility",
      "receiving_application",
      "receiving_facility",
      "message_date/time",
      "security",
      "message_type",
      "message_control_ID",
      "processing_ID",
      "version_ID",
      "sequence_number",
      "continuation_pointer",
      "accept_ack_type",
      "application_ack_type",
      "country_code",
      "character_set",
      "principal_language",
      "alt_character_set_handling"
    ],
    "MSA": [
      "segment_ID",
      "acknowledgment_code",
      "message_control_ID",
      "text_message",
      "expected_sequence_number",
      "delayed_acknowledgment_type",
      "error_condition"
    ],
    "ERR": [
      "segment_ID",
      "ERR-1-error_code_&_loc"
    ]
  }

  for (segment in segments) {
    var segment_name = segment splitBy "|"[0]
    var fields = segment splitBy "|"

    if (segment_mapping[segment_name] != null) {
      var segment_object = {}

      for (index in segment_mapping[segment_name]) {
        var field_name = segment_mapping[segment_name][index]
        segment_object[field_name] = fields[index]
      }

      if (parsed_message[segment_name] == null) {
        parsed_message[segment_name] = []
      }
      parsed_message[segment_name] ++ segment_object
    }
  }

  return parsed_message
}