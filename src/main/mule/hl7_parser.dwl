package hl7.parser

fun parse_hl7_message(str_message) {
  var segments = str_message splitBy '\r';
  var parsed_map = {};

  var segment_mapping = {
    'MSH': {
      'segment_ID': 0,
      'encoding_characters': 1,
      'sending_application': 2,
      'sending_facility': 3,
      'receiving_application': 4,
      'receiving_facility': 5,
      'message_date_time': 6,
      'security': 7,
      'message_type': 8,
      'message_control_ID': 9,
      'processing_ID': 10,
      'version_ID': 11,
      'sequence_number': 12,
      'continuation_pointer': 13,
      'accept_ack_type': 14,
      'application_ack_type': 15,
      'country_code': 16,
      'character_set': 17,
      'principal_language': 18,
      'alt_character_set_handling': 19
    },
    'MSA': {
      'segment_ID': 0,
      'acknowledgment_code': 1,
      'message_control_ID': 2,
      'text_message': 3,
      'expected_sequence_number': 4,
      'delayed_acknowledgment_type': 5,
      'error_condition': 6
    },
    'ERR': {
      'segment_ID': 0,
      'error_code_loc': 1
    }
  };

  for (segment in segments) {
    var segment_name = segment splitBy '|'[0];
    if (segment_mapping[segment_name] != null) {
      var fields = segment splitBy '|';
      var segment_data = {};
      for (field_name in segment_mapping[segment_name]) {
        var field_index = segment_mapping[segment_name][field_name];
        segment_data[field_name] = fields[field_index];
      }
      parsed_map[segment_name] = segment_data;
    }
  }

  return parsed_map;
}