package my.data.transform.project

fun process_ack_message(message_string: String): String {
  input_map = {}
  output_map = {}
  skip = false
  try {
    input_map = parse_hl7_message(message_string)
    output_map = {}
    if (input_map contains 'MSA') {
      if (input_map['MSA'].size() > 1) {
        print 'More than one MSA segment present'
      }
      msa_text_message = input_map['MSA'][0]['MSA-3-text_message']
      if (msa_text_message == null) {
        return ''
      }
      if (msa_text_message contains 'ZZZ') {
        skip = true
        print 'Message will be skipped'
      } else {
        print 'Message will be processed'
      }
    } else {
      print 'No MSA segments found'
      skip = false
    }
    if (skip) {
      output_map = {}
    } else {
      output_map['MSH'] = input_map['MSH']
      output_map['MSA'] = input_map['MSA']
    }
    return string(output_map)
  } catch (error) {
    return ''
  } finally {
    input_map = {}
    output_map = {}
  }
}