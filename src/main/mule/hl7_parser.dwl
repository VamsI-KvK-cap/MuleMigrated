package hl7.parser

%dw 2.0
output application/json

fun parse_hl7_message(str_message) {
  var segments = str_message splitBy '\n'
  var parsed_message = {}

  var segment_mapping = {
    'MSH': 'MSH_struct',
    'MSA': 'MSA_struct',
    'ERR': 'ERR_struct'
  }

  for (segment in segments) {
    var segment_parts = segment splitBy '|'
    var segment_id = segment_parts[0]
    var segment_structure = segment_mapping[segment_id]

    if (segment_structure != null) {
      parsed_message[segment_id] = []
      var segment_object = {}

      switch (segment_structure) {
        case 'MSH_struct':
          segment_object['segment_ID'] = segment_parts[0]
          segment_object['encoding_characters'] = segment_parts[1]
          segment_object['sending_application'] = segment_parts[2]
          segment_object['sending_facility'] = segment_parts[3]
          segment_object['receiving_application'] = segment_parts[4]
          segment_object['receiving_facility'] = segment_parts[5]
          segment_object['message_type'] = {
            'message_type': segment_parts[8] splitBy '^'
          }
          segment_object['message_control_ID'] = segment_parts[9]
          segment_object['processing_ID'] = segment_parts[10]
          segment_object['version_ID'] = segment_parts[11]
          break;
        case 'MSA_struct':
          segment_object['segment_ID'] = segment_parts[0]
          segment_object['acknowledgment_code'] = segment_parts[1]
          segment_object['message_control_ID'] = segment_parts[2]
          segment_object['text_message'] = segment_parts[3]
          break;
        case 'ERR_struct':
          segment_object['segment_ID'] = segment_parts[0]
          segment_object['error_code'] = segment_parts[1]
          break;
      }

      parsed_message[segment_id] ++ segment_object
    }
  }

  return parsed_message
}