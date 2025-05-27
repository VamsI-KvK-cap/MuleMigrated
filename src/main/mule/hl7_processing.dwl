package hl7.processing

%dw 2.0
output application/json
fun process_hl7_ack(message_string: String): String {
  var input_map = {}
  var output_map = {}
  try {
    input_map = parse_hl7_message(message_string)
    output_map = {}
    var skip = false
    if (input_map containsKey 'MSA') {
      var msa_segments = input_map['MSA']
      if (sizeOf(msa_segments) > 1) {
        // Log: More than one MSA segment present
      }
      if (msa_segments[0] containsKey 'MSA-3-text_message') {
        var msa_text_message = msa_segments[0]['MSA-3-text_message']
        if (msa_text_message contains 'ZZZ') {
          skip = true
          // Log: Message will be skipped
        } else {
          skip = false
          // Log: Message will be processed
        }
      } else {
        skip = true
        // Log: MSA-3-text_message not found
      }
    } else {
      // Log: No MSA segments found
      skip = false
    }
    if (skip) {
      output_map = {}
    } else {
      output_map['MSH'] = input_map['MSH']
      output_map['MSA'] = input_map['MSA']
    }
    var output_string = write(output_map, 'application/hl7')
    return output_string
  } catch (error) {
    return ''
  }
}