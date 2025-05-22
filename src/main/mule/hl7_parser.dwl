package hl7.parser

fun parse_hl7_message(str_message):
  segments = str_message splitBy '\r'
  parsed_map = {}

  for segment in segments:
    fields = segment splitBy '|'
    segment_name = fields[0]
    parsed_map[segment_name] = []

    field_map = {}

    if segment_name == 'MSH':
      field_map['segment_ID'] = fields[0]
      field_map['encoding_characters'] = fields[1]
      field_map['sending_application'] = parse_hd(fields[2])
      field_map['sending_facility'] = parse_hd(fields[3])
      field_map['receiving_application'] = parse_hd(fields[4])
      field_map['receiving_facility'] = parse_hd(fields[5])
      field_map['message_type'] = parse_msh9(fields[8])
      field_map['processing_ID'] = parse_pt(fields[10])
      field_map['version_ID'] = parse_vid(fields[11])
      field_map['datetime_of_message'] = fields[6]
      field_map['security'] = fields[7]
      field_map['message_control_ID'] = fields[9]
      field_map['processing_mode'] = fields[12]

    else if segment_name == 'MSA':
      field_map['segment_ID'] = fields[0]
      field_map['acknowledgment_code'] = fields[1]
      field_map['message_control_ID'] = fields[2]
      field_map['text_message'] = fields[3]
      field_map['expected_sequence_number'] = fields[4]
      field_map['delayed_acknowledgment_type'] = fields[5]

    else if segment_name == 'ERR':
      field_map['segment_ID'] = fields[0]
      field_map['error_code'] = parse_ce(fields[1])
      field_map['error_severity'] = fields[2]
      field_map['application_error_code'] = fields[3]
      field_map['error_location'] = fields[4]
      field_map['user_message'] = fields[5]

    parsed_map[segment_name].add(field_map)

  return parsed_map

fun parse_hd(field):
  return {
    'namespace_ID': field.split('~')[0],
    'universal_ID': field.split('~')[1],
    'universal_ID_type': field.split('~')[2]
  }

fun parse_pt(field):
  return {
    'processing_ID': field.split('~')[0],
    'processing_mode': field.split('~')[1]
  }

fun parse_vid(field):
  return {
    'version_ID': field.split('~')[0],
    'internationalization_code': field.split('~')[1],
    'international_version_ID': field.split('~')[2]
  }

fun parse_ce(field):
  return {
    'ID_code': field.split('~')[0],
    'text': field.split('~')[1],
    'coding_scheme': field.split('~')[2],
    'alternate_ID': field.split('~')[3],
    'alternate_text': field.split('~')[4],
    'alternate_coding_scheme': field.split('~')[5]
  }

fun parse_msh9(field):
  return {
    'message_type': field.split('^')[0],
    'trigger_event': field.split('^')[1],
    'message_structure': field.split('^')[2]
  }