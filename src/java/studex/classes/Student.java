package studex.classes;

public class Student {

    private int userId;
    private String name;
    private String email;
    private String phoneNo;
    private String enrollmentDate;
    private String guardianName;

    public Student(int userId, String name, String email, String phoneNo, String enrollmentDate) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.phoneNo = phoneNo;
        this.enrollmentDate = enrollmentDate;
    }

    public Student(int userId, String name, String email, String phoneNo, String enrollmentDate, String guardianName) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.phoneNo = phoneNo;
        this.enrollmentDate = enrollmentDate;
        this.guardianName = guardianName;
    }

    public int getUserId() {
        return userId;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPhoneNo() {
        return phoneNo;
    }

    public String getEnrollDate() {
        return enrollmentDate;
    }

    public String getGuardianName() {
        return guardianName;
    }
}
