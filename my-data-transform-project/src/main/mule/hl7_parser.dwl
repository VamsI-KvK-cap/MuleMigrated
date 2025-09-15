package my.data.transform.project

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
    'sending_application': parse_HD(fields[2]),
    'sending_facility': parse_HD(fields[3]),
    'receiving_application': parse_HD(fields[4]),
    'receiving_facility': parse_HD(fields[5]),
    'message_date_time': fields[6],
    'message_type': parse_message_type(fields[8]),
    'processing_ID': parse_PT(fields[10]),
    'version_ID': parse_VID(fields[11]),
    'principal_language': parse_CE(fields[18])
  };
}

fun parse_MSA(segment) {
  var fields = segment splitBy '|';
  return {
    'segment_ID': fields[0],
    'acknowledgment_code': fields[1],
    'message_control_ID': fields[2],
    'error_condition': parse_CE(fields[6])
  };
}

fun parse_ERR(segment) {
  var fields = segment splitBy '|';
  return {
    'segment_ID': fields[0],
    'error_code': parse_CE(fields[1])
  };
}

fun parse_HD(field) {
  var subfields = field splitBy '^';
  return {
    'namespace_ID': subfields[0],
    'universal_ID': subfields[1],
    'universal_ID_type': subfields[2]
  };
}

fun parse_CE(field) {
  var subfields = field splitBy '^';
  return {
    'ID_code': subfields[0],
    'text': subfields[1],
    'coding_scheme': subfields[2]
  };
}

fun parse_PT(field) {
  var subfields = field splitBy '^';
  return {
    'processing_ID': subfields[0],
    'processing_mode': subfields[1]
  };
}

fun parse_VID(field) {
  var subfields = field splitBy '^';
  return {
    'version_ID': subfields[0],
    'internationalization_code': subfields[1]
  };
}

fun parse_message_type(field) {
  var subfields = field splitBy '^';
  return {
    'message_type': subfields[0],
    'trigger_event': subfields[1],
    'message_structure': subfields[2]
  };
}