%dw 2.0
output application/json skipNullOn = "everywhere"

var defaultArea = "Internal"

fun getArea(area) = (
    if (isEmpty(area)) (
        defaultArea
    ) else (
        lower(area) match {
            case a if a contains "mulesoft" -> "MS"
            case a if a contains "salesforce" -> "SF"
            else -> defaultArea
        }
    )
)

fun getBirthdate(birthdate) = (
    birthdate as Date {format: "yyyy-MM-dd"} as String {format: "yyyyMMdd"}
) default null

fun getPhone(phone) = do {
    var newPhone = flatten(phone scan /\d/) joinBy ""
    ---
    if (!isEmpty(newPhone) and sizeOf(newPhone) >= 10) {
        countryCode: newPhone[-11],
        areaCode: newPhone[-10 to -8],
        number: newPhone[-7 to -1]
    } else null
}
---
{
    eid: payload.EmployeeId,
    phone: getPhone(payload.PhoneNumber),
    firstName: payload.FirstName,
    lastName: payload.LastName,
    birthdate: getBirthdate(payload.Birthdate),
    title: payload.Title,
    area: getArea(payload.Title)
}