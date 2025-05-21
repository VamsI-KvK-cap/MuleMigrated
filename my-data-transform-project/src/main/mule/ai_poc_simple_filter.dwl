package my.data.transform.project;

%dw 2.0
output application/json
fun ai_poc_simple_filter(message_string: String): String = 
    do {
        var input_map = {};
        var output_map = {};
        var skip = false;
        input_map = parse_hl7_message(message_string);
        output_map = {};
        if (input_map contains 'MSA' and sizeOf(input_map['MSA']) > 0) {
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
        var output_string = write(output_map, 'application/json');
        input_map = {};
        output_map = {};
        output_string;
    } catch (e) {
        "";
    }