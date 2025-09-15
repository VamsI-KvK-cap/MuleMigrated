package hl7.parser

fun parse_hl7_message(str_message) {
  var segments = str_message splitBy '\r';
  var parsed_map = {};

  for (segment in segments) {
    var segment_name = segment splitBy '|'[0];
    var fields = segment splitBy '|';
    parsed_map[segment_name] = [];

    if (segment_name == 'MSH') {
      parsed_map[segment_name][0] = {
        'segment_ID': fields[0],
        'encoding_characters': fields[1],
        'sending_application': fields[2],
        'sending_facility': fields[3],
        'receiving_application': fields[4],
        'receiving_facility': fields[5],
        'message_date_time': fields[6],
        'security': fields[7],
        'message_type': {
          'message_type': fields[8] splitBy '^'[0],
          'trigger_event': fields[8] splitBy '^'[1],
          'message_structure': fields[8] splitBy '^'[2]
        },
        'message_control_ID': fields[9],
        'processing_ID': {
          'processing_ID': fields[10] splitBy '^'[0],
          'processing_mode': fields[10] splitBy '^'[1]
        },
        'version_ID': {
          'version_ID': fields[11] splitBy '^'[0],
          'internationalization_code': fields[11] splitBy '^'[1],
          'international_version_ID': fields[11] splitBy '^'[2]
        },
        'sequence_number': fields[12],
        'continuation_pointer': fields[13],
        'accept_ack_type': fields[14],
        'application_ack_type': fields[15],
        'country_code': fields[16],
        'character_set': fields[17] splitBy '^',
        'principal_language': fields[18] splitBy '^',
        'alt_character_set_handling': fields[19]
      };
    } else if (segment_name == 'MSA') {
      parsed_map[segment_name][0] = {
        'segment_ID': fields[0],
        'acknowledgment_code': fields[1],
        'message_control_ID': fields[2],
        'text_message': fields[3],
        'expected_sequence_number': fields[4],
        'delayed_acknowledgment_type': fields[5],
        'error_condition': fields[6] splitBy '^'
      };
    } else if (segment_name == 'ERR') {
      parsed_map[segment_name][0] = {
        'segment_ID': fields[0],
        'error_details': []
      };
      for (i in 1 to fields.length - 1) {
        var error_fields = fields[i] splitBy '|';
        parsed_map[segment_name][0]['error_details'][i - 1] = {
          'segment_ID': error_fields[0],
          'sequence': error_fields[1],
          'field_position': error_fields[2],
          'error_code': error_fields[3] splitBy '^'
        };
      }
    } else if (segment_name == 'VID') {
      parsed_map[segment_name][0] = {
        'version_ID': fields[0],
        'internationalization_code': fields[1],
        'international_version_ID': fields[2]
      };
    } else if (segment_name == 'PT') {
      parsed_map[segment_name][0] = {
        'processing_ID': fields[0],
        'processing_mode': fields[1]
      };
    }
  }

  return parsed_map;
}