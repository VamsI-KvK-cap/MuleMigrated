package dw.ai_poc_simple_filter;

import dw::core::Core;
import dw::core::Error;
import dw::core::Log;

fun ai_poc_simple_filter(message_string: String): String {
  var input_map = {};
  var output_map = {};
  var skip = false;
  try {
    input_map = parse_hl7_message(message_string);
    output_map = {};
    if (input_map['MSA']) {
      if (input_map['MSA'].length > 1) {
        Log::info('More than one MSA segment present.');
      }
      var msa_text_message = input_map['MSA'][0]['MSA-3-text_message'];
      if (msa_text_message contains 'ZZZ') {
        skip = true;
        Log::info('Message will be skipped.');
      } else {
        Log::info('Message will be processed.');
      }
    } else {
      Log::info('No MSA segments found.');
      skip = false;
    }
    if (skip) {
      output_map = {};
    } else {
      output_map['MSH'] = input_map['MSH'];
      output_map['MSA'] = input_map['MSA'];
    }
    var output_string = to_string(output_map);
    input_map = {};
    output_map = {};
    return output_string;
  } catch (error) {
    Log::error('Error occurred: ' ++ error);
    return '';
  }
}