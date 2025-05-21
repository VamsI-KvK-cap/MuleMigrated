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
        'message_type': 8,
        'trigger_event': 9,
        'message_structure': 10
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
      'error_code': {
        'segment_ID': 1,
        'sequence': 2,
        'field_position': 3,
        'error_code': 4
      }
    },
    'VID': {
      'version_ID': 0,
      'internationalization_code': 1,
      'international_version_ID': 2
    },
    'PT': {
      'processing_ID': 0,
      'processing_mode': 1
    },
    'CE': {
      'ID_code': 0,
      'text': 1,
      'coding_scheme': 2,
      'alternate_ID': 3,
      'alternate_text': 4,
      'alternate_coding_scheme': 5
    }
  };

  for (segment in segments) {
    var segment_name = segment splitBy '|'[0];
    var fields = segment splitBy '|';

    if (!parsed_map[segment_name]) {
      parsed_map[segment_name] = [];
    }

    var field_map = {};
    var mapping = segment_mapping[segment_name];

    if (mapping != null) {
      for (field_name in mapping) {
        if (isObject(mapping[field_name])) {
          field_map[field_name] = {};
          for (component_name in mapping[field_name]) {
            field_map[field_name][component_name] = fields[mapping[field_name][component_name]];
          }
        } else {
          field_map[field_name] = fields[mapping[field_name]];
        }
      }
      parsed_map[segment_name] = parsed_map[segment_name] ++ [field_map];
    }
  }

  return parsed_map;
}