package main.mule

%dw 2.0
output application/json
import * from dw::core::Strings
import parse_hl7_message from dw::your::external::dwl

fun process_hl7_ack(message_string: String): String {
  var input_map = {}
  var output_map = {}
  input_map = parse_hl7_message(message_string)
  output_map = {}
  var skip = false
  if (input_map contains 'MSA') {
    var msa_message = input_map['MSA'][0]['MSA-3-text_message']
    if (msa_message contains 'ZZZ') {
      skip = true
    }
  }
  if (skip) {
    output_map = {}
  } else {
    output_map['MSH'] = input_map['MSH']
    output_map['MSA'] = input_map['MSA']
  }
  var result = write(output_map, 'application/json')
  input_map = {}
  output_map = {}
  return result
}