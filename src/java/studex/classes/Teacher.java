package studex.classes;

public class Teacher {

    private int userId;
    private String name;
    private String email;
    private String phoneNo;
    private String enrollmentDate;
    private String className;
     
    public Teacher(int userId, String name, String email, String phoneNo, String enrollmentDate, String className) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.phoneNo = phoneNo;
        this.className = className;
        this.enrollmentDate = enrollmentDate;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNo() {
        return phoneNo;
    }

    public void setPhoneNo(String phoneNo) {
        this.phoneNo = phoneNo;
    }

    public String getEnrollDate() {
        return enrollmentDate;
    }

    public void setEnrollDate(String enrollmentDate) {
        this.enrollmentDate = enrollmentDate;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

}
