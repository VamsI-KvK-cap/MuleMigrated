package hl7.parser

%dw 2.0
output application/json

fun parse_hl7_message(str_message) {
  var segments = str_message splitBy '\r'
  var parsed_map = {}

  var segment_mapping = {
    'MSA': 'MSA_struct',
    'ERR': 'ERR_struct',
    'ACK': 'ACK_struct',
    'MSH': 'MSH_struct'
  }

  for (segment in segments) {
    var segment_parts = segment splitBy '|'
    var segment_id = segment_parts[0]
    var segment_structure = segment_mapping[segment_id]

    if (segment_structure != null) {
      parsed_map[segment_id] = []
      var segment_object = {}

      switch (segment_structure) {
        case 'MSA_struct':
          segment_object['segment_ID'] = segment_parts[0]
          segment_object['MSA-1-acknowledgment_code'] = segment_parts[1]
          segment_object['MSA-2-message_control_ID'] = segment_parts[2]
          segment_object['MSA-3-text_message'] = segment_parts[3]
          segment_object['MSA-4-expected_sequence_number'] = segment_parts[4]
          segment_object['MSA-5-delayed_acknowledgment_type'] = segment_parts[5]
          segment_object['MSA-6-error_condition'] = segment_parts[6] != null ? parse_ce(segment_parts[6]) : null
          break;
        case 'ERR_struct':
          segment_object['segment_ID'] = segment_parts[0]
          segment_object['ERR-1-error_code_&_loc'] = []
          for (i in 1 to (segment_parts.size() - 1)) {
            var error_code_parts = segment_parts[i] splitBy '^'
            var error_code_object = {
              'segment_ID': error_code_parts[0],
              'sequence': error_code_parts[1],
              'field_position': error_code_parts[2],
              'error_code': parse_ce(error_code_parts[3])
            }
            segment_object['ERR-1-error_code_&_loc'] ++= [error_code_object]
          }
          break;
        case 'ACK_struct':
          segment_object['segment_ID'] = segment_parts[0]
          segment_object['ACK-1-acknowledgment_code'] = segment_parts[1]
          segment_object['ACK-2-message_control_ID'] = segment_parts[2]
          segment_object['ACK-3-text_message'] = segment_parts[3]
          break;
        case 'MSH_struct':
          segment_object['segment_ID'] = segment_parts[0]
          segment_object['MSH-1-field_separator'] = segment_parts[1]
          segment_object['MSH-2-encoding_characters'] = segment_parts[2]
          segment_object['MSH-3-sending_application'] = segment_parts[3]
          segment_object['MSH-4-sending_facility'] = segment_parts[4]
          segment_object['MSH-5-receiving_application'] = segment_parts[5]
          segment_object['MSH-6-receiving_facility'] = segment_parts[6]
          segment_object['MSH-7-date_time_of_message'] = segment_parts[7]
          segment_object['MSH-8-security'] = segment_parts[8]
          segment_object['MSH-9-message_type'] = segment_parts[9]
          segment_object['MSH-10-message_control_ID'] = segment_parts[10]
          segment_object['MSH-11-processing_id'] = segment_parts[11]
          segment_object['MSH-12-version_ID'] = segment_parts[12]
          break;
      }

      parsed_map[segment_id] ++= [segment_object]
    }
  }

  return parsed_map
}

fun parse_ce(ce_string) {
  var ce_parts = ce_string splitBy '|'
  return {
    'ID_code': ce_parts[0],
    'text': ce_parts[1],
    'coding_scheme': ce_parts[2],
    'alternate_ID': ce_parts[3],
    'alternate_text': ce_parts[4],
    'alternate_coding_scheme': ce_parts[5]
  }
}