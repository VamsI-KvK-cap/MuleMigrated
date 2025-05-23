package hl7.parser

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
    'VID': {
      'version_ID': 0,
      'internationalization_code': 1,
      'international_version_ID': 2
    },
    'MSH': {
      'MSH-2-encoding_characters': 1,
      'MSH-3-sending_application': 2,
      'MSH-4-sending_facility': 3,
      'MSH-5-receiving_application': 4,
      'MSH-6-receiving_facility': 5,
      'MSH-9-message_type': 8,
      'MSH-10-message_control_ID': 9,
      'MSH-11-processing_ID': 10,
      'MSH-12-version_ID': 11
    },
    'ERR': {
      'ERR-1-error_code_&_loc': 1
    }
  };

  for (segment in segments) {
    var segment_name = segment splitBy '|'[0];
    if (segment_mapping[segment_name] != null) {
      var fields = segment splitBy '|';
      var segment_data = {};

      for (field_name, index in segment_mapping[segment_name]) {
        segment_data[field_name] = fields[index];
      }

      parsed_map[segment_name] = segment_data;
    }
  }

  return parsed_map;
}