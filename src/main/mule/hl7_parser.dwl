package hl7.parser

%dw 2.0
output application/json

fun parse_hl7_message(str_message) {
  var segments = str_message splitBy '\r'
  var parsed_message = {}

  var segment_mapping = {
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
      'error_code': 1
    }
  }

  for (segment in segments) {
    var segment_type = segment splitBy '|'
    var segment_name = segment_type[0]

    var segment_object = []

    if (segment_mapping[segment_name]) {
      var fields = segment_mapping[segment_name]
      var segment_data = {}

      for (field_name, field_index in fields) {
        segment_data[field_name] = segment_type[field_index]
      }

      parsed_message[segment_name] = parsed_message[segment_name] ++ [segment_data]
    }
  }

  return parsed_message
}