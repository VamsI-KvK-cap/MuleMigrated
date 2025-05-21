package my.data.transform.project;

fun parse_hl7_message(str_message) {
  var segments = str_message splitBy '\r';
  var parsed_map = {};

  var segment_mapping = {
    'MSA': {
      'MSA-1-acknowledgment_code': 1,
      'MSA-2-message_control_ID': 2,
      'MSA-3-text_message': 3,
      'MSA-4-expected_sequence_number': 4,
      'MSA-5-delayed_acknowledgment_type': 5,
      'MSA-6-error_condition': 6
    },
    'MSH': {
      'MSH-2-encoding_characters': 1,
      'MSH-3-sending_application': 2,
      'MSH-4-sending_facility': 3,
      'MSH-5-receiving_application': 4,
      'MSH-6-receiving_facility': 5,
      'MSH-7-message_date/time': 6,
      'MSH-8-security': 7,
      'MSH-9-message_type': 8,
      'MSH-10-message_control_ID': 9,
      'MSH-11-processing_ID': 10,
      'MSH-12-version_ID': 11,
      'MSH-13-sequence_number': 12,
      'MSH-14-continuation_pointer': 13,
      'MSH-15-accept_ack_type': 14,
      'MSH-16-application_ack_type': 15,
      'MSH-17-country_code': 16,
      'MSH-18-character_set': 17,
      'MSH-19-principal_language': 18,
      'MSH-20-alt_character_set_handling': 19
    },
    'ERR': {
      'ERR-1-error_code_&_loc': 1
    },
    'ACK': {
      'MSH': 0,
      'MSA': 1,
      'ERR': 2
    }
  };

  for (segment in segments) {
    var segment_name = segment splitBy '|'[0];
    var fields = segment splitBy '|';

    if (segment_mapping[segment_name] != null) {
      parsed_map[segment_name] = {};
      for (field_name in segment_mapping[segment_name]) {
        var field_index = segment_mapping[segment_name][field_name];
        parsed_map[segment_name][field_name] = fields[field_index];
      }
    }
  }

  return parsed_map;
}