package hl7;

fun process_ack_message(message_string: String): String {
  var input_map = {};
  var output_map = {};
  input_map = parse_hl7_message(message_string);
  output_map = {};
  var skip = false;
  if (input_map['MSA'] != null) {
    var msa_message = input_map['MSA'][0]['MSA-3-text_message'];
    if (msa_message contains 'ZZZ') {
      skip = true;
    }
  }
  if (skip) {
    output_map = {};
  } else {
    output_map['MSH'] = input_map['MSH'];
    output_map['MSA'] = input_map['MSA'];
  }
  var hl7_string = convert_to_hl7_string(output_map);
  input_map = {};
  output_map = {};
  return hl7_string;
}