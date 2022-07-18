import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { GridComponent } from './components/grid/grid.component';
import { LoaderComponent } from './components/loader/loader.component';

const routes: Routes = [
  {
    path: 'grid',
    component: GridComponent,
  },
  {
    path: 'loader',
    component: LoaderComponent,
  },
  {
    path: '**',
    redirectTo: 'grid',
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
