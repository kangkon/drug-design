from pymol import cmd
import argh

@argh.arg('receptor', help="Receptor Filename")
@argh.arg('ligand', help="Ligand Filename")
@argh.arg('--output', help="Output Filename")
def prepare_complex(receptor, ligand, output="complex.pdb"):
    """
    Prepare PDB complex from separate receptor and ligand files
    """
    cmd.delete('all')
    cmd.load(receptor, "receptor")
    #cmd.alter('name receptor', 'chain="A"')
    cmd.load(ligand, "ligand")
    #cmd.alter('name ligand', 'chain="B"')
    #cmd.png('./test2.png', 1000, 1000)
    cmd.set('pdb_conect_all', 'on')
    cmd.save(output)
    
if __name__ == '__main__':
    argh.dispatch_command(prepare_complex)