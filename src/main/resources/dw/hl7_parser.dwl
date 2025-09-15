package dw.hl7;

fun parse_hl7_message(str_message) {
  var segments = str_message splitBy '\r';
  var parsed_map = {};

  var segment_mapping = {
    'MSH': 'MSH_struct',
    'MSA': 'MSA_struct',
    'ERR': 'ERR_struct'
  };

  for (segment in segments) {
    var segment_id = segment splitBy '|'[0];
    var segment_structure = segment_mapping[segment_id];

    parsed_map[segment_id] = [];
    var segment_fields = segment splitBy '|';

    if (segment_structure == 'MSH_struct') {
      parsed_map[segment_id][0] = {
        'segment_ID': segment_fields[0],
        'encoding_characters': segment_fields[1],
        'sending_application': segment_fields[2],
        'sending_facility': segment_fields[3],
        'receiving_application': segment_fields[4],
        'receiving_facility': segment_fields[5],
        'message_date_time': segment_fields[6],
        'security': segment_fields[7],
        'message_type': {
          'message_type': segment_fields[8] splitBy '^'[0],
          'trigger_event': segment_fields[8] splitBy '^'[1],
          'message_structure': segment_fields[8] splitBy '^'[2]
        },
        'message_control_ID': segment_fields[9],
        'processing_ID': {
          'processing_ID': segment_fields[10] splitBy '|'[0],
          'processing_mode': segment_fields[10] splitBy '|'[1]
        },
        'version_ID': {
          'version_ID': segment_fields[11] splitBy '|'[0],
          'internationalization_code': segment_fields[11] splitBy '|'[1],
          'international_version_ID': segment_fields[11] splitBy '|'[2]
        }
      };
    } else if (segment_structure == 'MSA_struct') {
      parsed_map[segment_id][0] = {
        'segment_ID': segment_fields[0],
        'acknowledgment_code': segment_fields[1],
        'message_control_ID': segment_fields[2],
        'text_message': segment_fields[3],
        'expected_sequence_number': segment_fields[4],
        'delayed_acknowledgment_type': segment_fields[5],
        'error_condition': segment_fields[6] splitBy '|'
      };
    } else if (segment_structure == 'ERR_struct') {
      parsed_map[segment_id][0] = {
        'segment_ID': segment_fields[0],
        'error_details': []
      };
      for (i in 1 to segment_fields.length - 1) {
        var error_detail = segment_fields[i] splitBy '|';
        parsed_map[segment_id][0]['error_details'][i - 1] = {
          'segment_ID': error_detail[0],
          'sequence': error_detail[1],
          'field_position': error_detail[2],
          'error_code': error_detail[3] splitBy '|'
        };
      }
    }
  }

  return parsed_map;
}