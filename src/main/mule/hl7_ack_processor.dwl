package hl7.processor

%dw 2.0
output application/json
fun process_ack_message(message_string: String): String {
  var input_map = {}
  var output_map = {}
  try {
    input_map = parse_hl7_message(message_string)
    var skip = false
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
        log('Message will be processed.')
      }
    } else {
      return ''
    }
    if (!skip) {
      output_map['MSH'] = input_map['MSH']
      output_map['MSA'] = input_map['MSA']
    }
    var output_string = write(output_map, 'application/json')
    input_map = {}
    output_map = {}
    return output_string
  } catch (error) {
    return ''
  }
}