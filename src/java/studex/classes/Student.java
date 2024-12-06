package studex.classes;

public class Student {
    private int userId;
    private String name;
    private String email;
    private String phoneNo;
    private String className;

    public Student(int userId, String name, String email, String phoneNo, String className) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.phoneNo = phoneNo;
        this.className = className;
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

    public String getClassName() {
        return className;
    }
}
