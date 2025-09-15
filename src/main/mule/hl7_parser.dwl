package hl7.parser

fun parse_hl7_message(str_message) {
  var segments = str_message splitBy '\r';
  var parsed_map = {};

  var segment_mapping = {
    'MSH': 'MSH_struct',
    'MSA': 'MSA_struct',
    'ERR': 'ERR_struct'
  };

  for (var segment in segments) {
    var segment_id = segment splitBy '|'[0];
    var segment_structure = segment_mapping[segment_id];

    if (segment_structure == 'MSH_struct') {
      parsed_map['MSH'] = parse_MSH(segment);
    } else if (segment_structure == 'MSA_struct') {
      parsed_map['MSA'] = parse_MSA(segment);
    } else if (segment_structure == 'ERR_struct') {
      parsed_map['ERR'] = parse_ERR(segment);
    }
  }

  return parsed_map;
}

fun parse_MSH(segment) {
  var fields = segment splitBy '|';
  return {
    'segment_ID': fields[0],
    'encoding_characters': fields[1],
    'sending_application': fields[2],
    'sending_facility': fields[3],
    'receiving_application': fields[4],
    'receiving_facility': fields[5],
    'message_type': parse_message_type(fields[8]),
    'message_control_ID': fields[9],
    'processing_ID': parse_processing_ID(fields[10]),
    'version_ID': parse_version_ID(fields[11])
  };
}

fun parse_MSA(segment) {
  var fields = segment splitBy '|';
  return {
    'segment_ID': fields[0],
    'acknowledgment_code': fields[1],
    'message_control_ID': fields[2],
    'text_message': fields[3],
    'expected_sequence_number': fields[4],
    'delayed_acknowledgment_type': fields[5],
    'error_condition': parse_error_condition(fields[6])
  };
}

fun parse_ERR(segment) {
  var fields = segment splitBy '|';
  return {
    'segment_ID': fields[0],
    'error_details': parse_error_details(fields[1])
  };
}

fun parse_message_type(field) {
  var components = field splitBy '^';
  return {
    'message_type': components[0],
    'trigger_event': components[1],
    'message_structure': components[2]
  };
}

fun parse_processing_ID(field) {
  return field;
}

fun parse_version_ID(field) {
  return field;
}

fun parse_error_condition(field) {
  return field;
}

fun parse_error_details(field) {
  return field;
}