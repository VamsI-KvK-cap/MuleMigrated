package dw.hl7;

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
      'message_type': {
        'message_type': 8.0,
        'trigger_event': 8.1,
        'message_structure': 8.2
      },
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
      'error_details': {
        'segment_ID': 1,
        'sequence': 2,
        'field_position': 3,
        'error_code': 4
      }
    }
  };

  for (segment in segments) {
    var segment_type = segment splitBy '|'[0];
    var fields = segment splitBy '|';

    if (segment_mapping[segment_type] != null) {
      var segment_structure = segment_mapping[segment_type];
      var parsed_segment = {};

      for (field_name in segment_structure) {
        var field_position = segment_structure[field_name];
        if (isObject(field_position)) {
          parsed_segment[field_name] = {};
          for (component_name in field_position) {
            parsed_segment[field_name][component_name] = fields[field_position[component_name]];
          }
        } else {
          parsed_segment[field_name] = fields[field_position];
        }
      }

      parsed_map[segment_type] = parsed_segment;
    }
  }

  return parsed_map;
}