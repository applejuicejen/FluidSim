#ifndef FLUID_H
#define FLUID_H

#include <ngl/Vec3.h>
#include <vector>
#include <iostream>
#include "ngl/VertexArrayObject.h"

#include "Emitter.h"

class Fluid
{
public:
  Fluid();
  ~Fluid();
  void Initialize();
  void setFluidTimestep(float _timestep);
  void hashParticles(ngl::Vec3 _position, float _sl);
  int findNextPrime(int _num);
  bool isPrime(int _num);
  void fillHashTable();
  void Update();
  void Delete();
  void Reset();
  void setCell();
  void setVAO();
  void Draw();

//  struct data
//  {
//    ngl::Vec3 pos;
//    ngl::Vec3 colour;
//  };

private:
  Emitter m_particle_emitter;
  int m_total_num_particles;
  float m_dt;
//  ngl::Vec3 m_position;
//  ngl::Vec3 m_velocity;
//  ngl::Vec3 m_init_velocity;
//  ngl::Vec3 m_gravity;
//  ngl::Vec3 m_colour;
//  ngl::Vec3 m_state_colour;
//  float m_pressure;
//  ngl::Real m_size;

//  ngl::VertexArrayObject *cube_vao;
//  ngl::VertexArrayObject *state_vao;

};
#endif // FLUID_H

