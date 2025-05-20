package hl7.parser

fun parse_hl7_message(str_message) {
  var segments = str_message splitBy '\r';
  var parsed_map = {};

  var segment_mapping = {
    'MSA': {
      'sample-acknowledgment-code': 1,
      'sample-message-control-ID': 2,
      'sample-text-message': 3,
      'sample-expected-sequence-number': 4,
      'sample-delayed-acknowledgment-type': 5,
      'sample-error-condition': 6
    },
    'ERR': {
      'sample-segment-ID': 0,
      'sample-error-details': {
        'segment-ID': 1,
        'sequence': 2,
        'field-position': 3,
        'error-code': 4
      }
    },
    'MSH': {
      'sample-sending-application': 2,
      'sample-sending-facility': 3,
      'sample-receiving-application': 4,
      'sample-receiving-facility': 5,
      'sample-message-type': {
        'message-type': 8[0],
        'trigger-event': 8[1],
        'message-structure': 8[2]
      },
      'sample-message-control-ID': 9,
      'sample-processing-ID': 10,
      'sample-version-ID': 11
    }
  };

  for (segment in segments) {
    var segment_name = segment[0..3];
    var fields = segment splitBy '|';

    if (segment_mapping[segment_name] != null) {
      var segment_data = {};
      var mapping = segment_mapping[segment_name];

      for (field_index in 0 to fields.size() - 1) {
        var logical_name = mapping[field_index];
        if (logical_name != null) {
          if (typeof logical_name == 'object') {
            var nested_data = {};
            for (nested_index in mapping[logical_name]) {
              nested_data[nested_index] = fields[nested_index];
            }
            segment_data[logical_name] = nested_data;
          } else {
            segment_data[logical_name] = fields[field_index];
          }
        }
      }

      parsed_map[segment_name] = segment_data;
    }
  }

  return parsed_map;
}