%dw 2.0
output application/json
import * from dw::core::Strings

var lines = splitBy(payload, "\n")
var msh = splitBy(lines[0], "|")
var pid = splitBy(lines[1], "|")
var patientNameParts = splitBy(pid[5], "^")

---
{
  messageType: msh[8],
  messageId: msh[9],
  patientId: pid[3] splitBy("^")[0],
  patientName: patientNameParts[1] ++ " " ++ patientNameParts[0],
  birthDate: pid[7] as Date {format: "yyyyMMdd"} as String {format: "yyyy-MM-dd"},
  gender: pid[8]
}