package dw;

output application/json

fun ai_poc_simple_filter(message_string: String): String {
  var input_map = {}
  var output_map = {}
  var skip = false
  input_map = parse_hl7_message(message_string)
  output_map = {}
  if (input_map containsKey 'MSA') {
    var msa_segments = input_map['MSA']
    if (sizeOf(msa_segments) > 1) {
      log('More than one MSA segment present.')
    }
    var msa_text_message = msa_segments[0]['MSA-3-text_message']
    if (msa_text_message contains 'ZZZ') {
      skip = true
      log('Message will be skipped.')
    } else {
      skip = false
      log('Message will be processed.')
    }
  } else {
    log('No MSA segments found.')
    skip = false
  }
  if (skip) {
    output_map = {}
  } else {
    output_map['MSH'] = input_map['MSH']
    output_map['MSA'] = input_map['MSA']
  }
  var output_string = write(output_map, 'application/json')
  input_map = {}
  output_map = {}
  return output_string
}