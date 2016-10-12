var gulp = require('gulp');
var sass = require('gulp-sass');
var browserSync = require('browser-sync').create();
var coffee = require('gulp-coffee');
var concat = require('gulp-concat');
var useref = require('gulp-useref');
var gulpIf = require('gulp-if');
var uglify = require('gulp-uglify');
var cssnano = require('gulp-cssnano');



// Tasks

gulp.task('sass', function() {
    return gulp.src('src/sass/*.sass')
      .pipe(sass().on('error', function(err){console.log("Shit", err);}))
      .pipe(gulp.dest('src/css'))
      .pipe(browserSync.reload({
        stream: true
        }))
});

gulp.task('browserSync', function () {
    browserSync.init({
        server: {
            baseDir: 'src'
        },
        open: false
    })
});

gulp.task('coffee', function() {
    return gulp.src('src/coffee/*.coffee')
               .pipe(concat('main.coffee'))
               .pipe(coffee({bare: true}).on('error', function(err) {console.log("shit", err)}))
               .pipe(gulp.dest('src/js'))
               .pipe(browserSync.reload({
                  stream: true
                }));
});


gulp.task('images', function() {
  return gulp.src('src/img/*')
             .pipe(gulp.dest('dist/img'));
             });

gulp.task('build', ['sass', 'coffee'], function () {
  return gulp.src('src/*.html')
             .pipe(useref())
             .pipe(gulpIf('*.js', uglify()))
             .pipe(gulpIf('*.css', cssnano()))
             .pipe(gulp.dest('dist'));
             });

// browserSync must finish before other watch tasks
gulp.task('watch', ['browserSync', 'sass', 'coffee'], function() {
    gulp.watch('src/sass/*.sass', ['sass']);
    gulp.watch('src/coffee/*.coffee', ['coffee']);
    gulp.watch('src/*.html', browserSync.reload);
    gulp.watch('src/js/*.js', browserSync.reload);
});


