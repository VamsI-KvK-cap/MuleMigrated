package my.data.transform.project;

import dwl.core.*;

fun filter_ack_message(message_string: String): String {
  var input_map = {};
  var output_map = {};
  output_map = {};
  input_map = parse_hl7_message(message_string);
  var skip = false;
  
  if (input_map contains 'MSA' and input_map['MSA'].length > 0) {
    if (input_map['MSA'].length > 1) {
      log('More than one MSA segment present.');
    }
    var msa_text_message = input_map['MSA'][0]['MSA-3-text_message'];
    if (msa_text_message contains 'ZZZ') {
      skip = true;
      log('Message will be skipped.');
    } else {
      log('Message will be processed.');
    }
  } else {
    log('No MSA segments found.');
  }
  
  if (!skip) {
    output_map['MSH'] = input_map['MSH'];
    output_map['MSA'] = input_map['MSA'];
  }
  
  var output_string = convert_output_map_to_string(output_map);
  input_map = {};
  output_map = {};
  
  return skip ? '' : output_string;
}