import { ComponentFixture, TestBed } from '@angular/core/testing';

import { WelcomeDivComponent } from './welcome-div.component';

describe('WelcomeDivComponent', () => {
  let component: WelcomeDivComponent;
  let fixture: ComponentFixture<WelcomeDivComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [WelcomeDivComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(WelcomeDivComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
