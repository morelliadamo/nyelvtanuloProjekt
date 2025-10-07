import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { HeaderComponent } from './header/header.component';
import { WelcomeDivComponent } from './welcome-div/welcome-div.component';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, HeaderComponent, WelcomeDivComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css',
})
export class AppComponent {
  title = 'Frontend';
}
