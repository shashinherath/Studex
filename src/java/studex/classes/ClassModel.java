package studex.classes;

public class ClassModel {
    private int classId;
    private String className;
    private int year;

    public ClassModel(int classId, String className, int year) {
        this.classId = classId;
        this.className = className;
        this.year = year;
    }

    public int getClassId() {
        return classId;
    }

    public String getClassName() {
        return className;
    }

    public int getYear() {
        return year;
    }
}
