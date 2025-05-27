package hl7.filter

%dw 2.0
output application/json
import * from dw::core::Strings
import * from dw::core::Objects

fun process_hl7_ack(message_string: String): String {
  var input_map = {}
  var output_map = {}
  var skip = false
  input_map = parse_hl7_message(message_string)
  
  if (input_map.MSA) {
    var msa_segment = input_map.MSA[0]
    var msa_text_message = msa_segment['MSA-3-text_message']
    if (msa_text_message contains 'ZZZ') {
      skip = true
    }
  } else {
    skip = false
  }
  
  if (!skip) {
    if (input_map.MSH) {
      output_map.MSH = input_map.MSH[0]
    }
    output_map.MSA = input_map.MSA[0]
  }
  
  var output_string = write(output_map, 'application/json')
  return skip ? '' : output_string
}