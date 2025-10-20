package DAO;

import java.util.List;

import model.CourseModel;

public interface CourseDAO {
    void createCourse(CourseModel course);
    CourseModel getCourseById(int id);
    List<CourseModel> getAllCourses();
    void updateCourse(CourseModel course);
    void deleteCourse(int id);
}
