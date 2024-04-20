class Job {
  String company;
  String key;
  String deadline;
  String jobdec;
  String jobtitle;
  String location;
  String mail;
  String salary;
  String skills;
  String uid;
  String image;
  List connectionList;

  Job({
    required this.key,
    required this.company,
    required this.deadline,
    required this.jobdec,
    required this.jobtitle,
    required this.location,
    required this.mail,
    required this.salary,
    required this.skills,
    required this.uid,
    required this.image,
    required this.connectionList,
  });
}
