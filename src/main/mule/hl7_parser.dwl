%dw 2.0
output application/json

fun parse_hl7_message(str_message) {
  var segments = str_message splitBy '\r'
  var parsed_message = {}

  var segment_mapping = {
    'MSH': 'MSH_struct',
    'MSA': 'MSA_struct',
    'ERR': 'ERR_struct'
  }

  for (segment in segments) {
    var segment_parts = segment splitBy '|'
    var segment_name = segment_parts[0]
    var segment_structure = segment_mapping[segment_name]

    var segment_object = {}

    if (segment_structure == 'MSH_struct') {
      segment_object['segment_ID'] = segment_parts[0]
      segment_object['encoding_characters'] = segment_parts[1]
      segment_object['sending_application'] = segment_parts[2]
      segment_object['sending_facility'] = segment_parts[3]
      segment_object['receiving_application'] = segment_parts[4]
      segment_object['receiving_facility'] = segment_parts[5]
      segment_object['datetime_of_message'] = segment_parts[6]
      segment_object['message_type'] = segment_parts[7]
      segment_object['message_control_id'] = segment_parts[8]
      segment_object['processing_id'] = segment_parts[9]
      segment_object['version_id'] = segment_parts[10]
    } else if (segment_structure == 'MSA_struct') {
      segment_object['segment_ID'] = segment_parts[0]
      segment_object['acknowledgment_code'] = segment_parts[1]
      segment_object['message_control_id'] = segment_parts[2]
      segment_object['text_message'] = segment_parts[3]
    } else if (segment_structure == 'ERR_struct') {
      segment_object['segment_ID'] = segment_parts[0]
      segment_object['error_code'] = segment_parts[1]
      segment_object['error_severity'] = segment_parts[2]
      segment_object['error_location'] = segment_parts[3]
      segment_object['error_message'] = segment_parts[4]
    }

    parsed_message[segment_name] = (parsed_message[segment_name] default []) ++ [segment_object]
  }

  return parsed_message
}