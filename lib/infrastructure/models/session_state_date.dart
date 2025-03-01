
class SessionStateData {
  final String? currentTicketId;
  final bool showResults;

  SessionStateData(this.currentTicketId, this.showResults);

  Map<String, dynamic> toJson() {
   Map<String, dynamic> json = {
     'showResults': showResults,
   };
   if (currentTicketId != null) {
     json["currentTicketId"] = currentTicketId!;
   }
   return json;
  }

  static SessionStateData fromJson(Map<String, dynamic> json) {
    return SessionStateData(
      json['currentTicketId'] as String?,
      json['showResults'] as bool,
    );
  }
}